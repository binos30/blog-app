export const debouncePromise = (func, timeout = 400) => {
  let timer;

  return async function (...args) {
    return new Promise((resolve) => {
      const context = this;

      if (timer) clearTimeout(timer);
      timer = setTimeout(() => {
        timer = null;
        resolve(func.apply(context, args));
      }, timeout);
    });
  };
};
