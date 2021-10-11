export default ({ store }, inject) => {
  inject("toast", {
    show: value => {
      store.commit("setSnackbarMessage", value);
      store.commit("toggleSnackbar");
    },
    showUnexpectedError: () => {
      store.commit("setSnackbarMessage", "An unexpected error has occurred.");
      store.commit("toggleSnackbar");
    }
  });
};
