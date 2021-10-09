export const state = () => ({
  user: null,
  drawer: true,
  assets: {
    slp:
      "https://assets.coingecko.com/coins/images/10366/large/SLP.png?1578640057",
    arena:
      "https://chimeratribune.com/wp-content/uploads/2020/11/axieareanaswords.png",
    axie:
      "https://storage.googleapis.com/assets.axieinfinity.com/axies/5334859/axie/axie-full-transparent.png",
    scholar:
      "https://png.pngtree.com/element_origin_min_pic/17/09/17/58c7e2f4435c8bfc09400154cdd9b89e.jpg"
  }
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
