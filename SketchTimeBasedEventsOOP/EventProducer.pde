class EventProducer {
  private float mCounter = 0.0;
  private float mInterval = 1.0;
  private final EventReceiver mReceiver;
  private final Object mReceiverObject;
  private java.lang.reflect.Method mReceiverMethod;

  EventProducer(Object pEventReceiver, String pMethodName) {
    mReceiverObject = pEventReceiver;
    mReceiverMethod = registerCallback(pMethodName);
    mReceiver = null;
  }

  /**
   * usage:
   * ```
   * EventReceiver mEventReceiver = new EventReceiver() { 
   *    public void event() { 
   *       change_box_fill_color();
   *    }
   * };
   * EventProducer mEventProducer = new EventProducer(mEventReceiver);
   * ```
   */
  EventProducer(EventReceiver pEventReceiver) {
    mReceiverObject = null;
    mReceiverMethod = null;
    mReceiver = pEventReceiver;
  }

  void update(float pDelta) {
    mCounter += pDelta;
    if (mCounter > mInterval) {
      while (mCounter > mInterval) {
        mCounter -= mInterval;
      }
      if (mReceiverObject != null && mReceiverMethod != null) {
        invokeCallback();
      }
      if (mReceiver != null) {
        mReceiver.event();
      }
    }
  }

  void interval(float pInterval) {
    mInterval = pInterval;
  }

  void reset() {
    mCounter = 0.0;
  }

  float duration () {
    return mCounter / mInterval;
  }

  private java.lang.reflect.Method registerCallback(String methodName) {
    try {
      return mReceiverObject.getClass().getMethod(methodName);
    } 
    catch (SecurityException e) {
      System.err.println("@EventProducer :: SecurityException");
    } 
    catch (NoSuchMethodException e) {
      System.err.println("@EventProducer :: NoSuchMethodException");
    }
    return null;
  }

  private void invokeCallback() {
    try {
      mReceiverMethod.invoke(mReceiverObject);
    } 
    catch (IllegalArgumentException e) { 
      System.err.println("@EventProducer :: IllegalArgumentException");
    } 
    catch (IllegalAccessException e) { 
      System.err.println("@EventProducer :: IllegalAccessException");
    } 
    catch (java.lang.reflect.InvocationTargetException e) { 
      System.err.println("@EventProducer :: InvocationTargetException");
    }
  }
}

interface EventReceiver {
  void event();
}
