export const state = () => ({
  user: null
});

export const mutations = {
  setUser: (state, payload) => {
    state.user = payload;
  }
};

export const actions = {
  async fetchUser({ state, commit }, payload) {
    console.log("fetchUser", payload);

    const response = await this.$supabase
      .from("users")
      .select()
      .eq("id", payload?.user?.id)
      .single();

    if (response) {
      commit("setUser", response.data);
      console.log("state?.user", state?.user);
    }
  }
};
