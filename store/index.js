const github = "https://cdn-icons-png.flaticon.com/512/25/25231.png";
const discord =
  "https://www.freepnglogos.com/uploads/discord-logo-png/discord-logo-logodownload-download-logotipos-1.png";
const google =
  "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-icon-png-transparent-background-osteopathy-16.png";
const twitter =
  "https://www.freepnglogos.com/uploads/twitter-logo-png/twitter-logo-vector-png-clipart-1.png";
const twitch =
  "https://www.freepnglogos.com/uploads/twitch-logo-vector-png-2.png";
const facebook =
  "https://www.pngarts.com/files/10/Square-Facebook-Logo-PNG-High-Quality-Image.png";

export const state = () => ({
  user: null,
  drawer: true,
  oauthProviders: [
    {
      provider: "github",
      title: "GitHub",
      subtitle: "Create an account via GitHub",
      logo: github
    },
    {
      provider: "discord",
      title: "Discord",
      subtitle: "Create an account via Discord",
      logo: discord
    },
    {
      provider: "google",
      title: "Google",
      subtitle: "Create an account via Google",
      logo: google
    },
    {
      provider: "twitch",
      title: "Twitch",
      subtitle: "Create an account via Twitch",
      logo: twitch
    },
    {
      provider: "facebook",
      title: "Facebook",
      subtitle: "Create an account via Facebook",
      logo: facebook
    }
  ],
  assets: {
    github,
    discord,
    google,
    twitter,
    slp:
      "https://assets.coingecko.com/coins/images/10366/large/SLP.png?1578640057",
    arena:
      "https://chimeratribune.com/wp-content/uploads/2020/11/axieareanaswords.png"
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
