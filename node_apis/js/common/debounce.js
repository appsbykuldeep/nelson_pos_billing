class EasyDebounceOperation {
  constructor(callback, timer) {
    this.callback = callback;
    this.timer = timer;
  }
}

class EasyDebounce {
  static _operations = new Map();

  /**
   * Debounces a function by the given duration. If debounce is called again
   * with the same tag before the timeout, the previous call is cancelled.
   * @param {string} tag - Unique tag for the debounce operation.
   * @param {number} duration - Delay in milliseconds.
   * @param {Function} onExecute - Function to be executed after the delay.
   */
  static debounce(tag, duration, onExecute) {
    if (duration === 0) {
      const operation = EasyDebounce._operations.get(tag);
      if (operation) {
        clearTimeout(operation.timer);
        EasyDebounce._operations.delete(tag);
      }
      onExecute();
    } else {
      const existing = EasyDebounce._operations.get(tag);
      if (existing) {
        clearTimeout(existing.timer);
      }

      const timer = setTimeout(() => {
        const op = EasyDebounce._operations.get(tag);
        if (op) {
          clearTimeout(op.timer);
          EasyDebounce._operations.delete(tag);
          op.callback();
        }
      }, duration);

      EasyDebounce._operations.set(tag, new EasyDebounceOperation(onExecute, timer));
    }
  }

  /**
   * Immediately executes the callback associated with the given tag.
   * Does NOT cancel the timer.
   * @param {string} tag
   */
  static fire(tag) {
    const operation = EasyDebounce._operations.get(tag);
    if (operation) {
      operation.callback();
    }
  }

  /**
   * Cancels the debounce operation for the given tag.
   * @param {string} tag
   */
  static cancel(tag) {
    const operation = EasyDebounce._operations.get(tag);
    if (operation) {
      clearTimeout(operation.timer);
      EasyDebounce._operations.delete(tag);
    }
  }

  /**
   * Cancels all active debounce operations.
   */
  static cancelAll() {
    for (const operation of EasyDebounce._operations.values()) {
      clearTimeout(operation.timer);
    }
    EasyDebounce._operations.clear();
  }

  /**
   * Returns the count of active debounce operations.
   * @returns {number}
   */
  static count() {
    return EasyDebounce._operations.size;
  }
}


/**
 
const EasyDebounce = require('./EasyDebounce');

EasyDebounce.debounce('search', 300, () => {
  console.log('Debounced search function executed!');
});

setTimeout(() => {
  EasyDebounce.debounce('search', 300, () => {
    console.log('Updated debounce search call!');
  });
}, 100);

 */


module.exports = EasyDebounce;
