export const state = () => ({
  user: null,
  users: []
});

export const mutations = {
  setUser: (state, user) => {
    state.user = user;
  },

  setUsers: (state, payload) => {
    state.users = payload;
  }
};

export const actions = {
  async find({ commit }, id) {
    try {
      const { data, error } = await this.$supabase
        .from("get_team_members")
        .select()
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
  },

  async all({ commit }) {
    try {
      const { data, error } = await this.$supabase
        .from("get_team_members")
        .select()
        .order("share");

      if (error) {
        console.error(error);
        return null;
      }

      commit("setUsers", data);
      return data;
    } catch (error) {
      console.error(error);
      return [];
    }
  }
};
