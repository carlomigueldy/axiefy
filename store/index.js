export const state = () => ({
  user: null,
  drawer: true
});

export const mutations = {
  setUser: (state, payload) => {
    state.user = payload;
  },

  toggleDrawer: (state, payload) => {
    state.drawer = payload ?? !state.drawer;
  }
};

export const actions = {
  async fetchUser({ state, commit }, payload) {
    this.$log.info("fetchUser", payload);

    try {
      const response = await this.$supabase
        .from("users")
        .select()
        .eq("id", this.$auth.user?.id)
        .single();

      if (response) {
        commit("setUser", response.data);
        this.$log.info("state?.user", state?.user);
      }

      return response;
    } catch (error) {
      this.$log.error(error);
      return null;
    }
  }
};
