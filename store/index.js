export const state = () => ({
  user: null,
  drawer: true
});

export const mutations = {
  setUser: (state, payload) => {
    state.user = payload;
  },

  toggleDrawer: (state, _) => {
    state.drawer = !state.drawer;
  }
};

export const actions = {
  async fetchUser({ state, commit }, payload) {
    console.log("fetchUser", payload);

    const response = await this.$supabase
      .from("users")
      .select()
      .eq("id", this.$auth.user?.id)
      .single();

    if (response) {
      commit("setUser", response.data);
      console.log("state?.user", state?.user);
    }
  }
};
