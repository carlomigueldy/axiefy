export const state = () => ({
  user: null
});

export const mutations = {
  setUser: (state, user) => {
    state.user = user;
  }
};

export const actions = {
  async find({ commit }, id) {
    try {
      const { data, error } = await this.$supabase
        .from("users")
        .select("*, detail: team_members ( share )")
        .eq("id", id)
        .single();

      if (error) {
        console.error(error);
        return null;
      }

      commit("setUser", data);
      return data;
    } catch (error) {
      console.error(error);
      return null;
    }
  }
};
