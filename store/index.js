export const state = {
  user: null
};

export const mutations = {
  setUser: (state, payload) => {
    state.user = payload;
  }
};
