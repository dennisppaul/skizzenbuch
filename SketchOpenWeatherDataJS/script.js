const baseUrl = 'http://api.openweathermap.org/data/2.5/weather'
const updateInterval = 60000 * 5 // 5 Minuten
const numOscillators = 5

let oscillators = []
let audioContext

document.addEventListener('click', event => {
	initAudio()
	fetchWeather().catch(error => {
		console.log(error)
	})
})

setInterval(() => {
	fetchWeather().catch(error => {
		console.log(error)
	})
}, updateInterval)

function weatherToFrequencies (weather) {
	return [
		weather.main.temp, // Temperatur
		weather.main.humidity / 10, // Luftfeuchtigkeit
		weather.main.pressure / 100, // Luftdruck
		weather.wind.speed, // Windgeschwindigkeit
		weather.visibility / 1000 // Sicht
	]
}

async function fetchWeather () {
	console.log('fetching weather')
	
	// const location = 'noch eine stadt hier'

	const appId = 'de10a66024f33619c09ae7378e733dd5'

	const response = await fetch(`${baseUrl}?q=${city}&appid=${appId}&units=metric`)
	const weather = await response.json()

	const frequencies = weatherToFrequencies(weather)

	console.log(weather)
	console.log(frequencies)

	for (let i = 0; i < numOscillators; i++) {
		oscillators[i].frequency.setValueAtTime(frequencies[i], audioContext.currentTime)
	}
}

function initAudio () {
	const AudioContext = window.AudioContext || window.webkitAudioContext
	audioContext = new AudioContext()

	for (let i = 0; i < numOscillators; i++) {
		const oscillator = audioContext.createOscillator()
		oscillator.type = 'sine'
		oscillator.frequency.setValueAtTime(0, audioContext.currentTime)
		oscillator.connect(audioContext.destination)
		oscillator.start()

		oscillators.push(oscillator)
	}
}