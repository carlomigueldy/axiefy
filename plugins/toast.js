export default ({ store }, inject) => {
  inject("toast", value => {
    store.commit("setSnackbarMessage", value)
    store.commit("toggleSnackbar");
  });
};
