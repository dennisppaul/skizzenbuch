class EventProducer {
  private float mCounter = 0.0;
  private float mInterval = 1.0;
  private final Object mReceiverObject;
  private java.lang.reflect.Method mReceiverMethod;

  EventProducer(Object pEventReceiver, String pMethodName) {
    mReceiverObject = pEventReceiver;
    mReceiverMethod = registerCallback(pMethodName);
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
    catch (Exception e) {
      System.err.println("@EventProducer :: registerCallback ( check the method name and signature )");
      e.printStackTrace();
    }
    return null;
  }

  private void invokeCallback() {
    try {
      mReceiverMethod.invoke(mReceiverObject);
    } 
    catch (Exception e) { 
      System.err.println("@EventProducer :: invokeCallback");
      e.printStackTrace();
    }
  }
}
