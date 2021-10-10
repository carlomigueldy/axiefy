import axios from "axios";

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
  scholars: [],
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
      "https://chimeratribune.com/wp-content/uploads/2020/11/axieareanaswords.png",
    axie:
      "https://storage.googleapis.com/assets.axieinfinity.com/axies/5334859/axie/axie-full-transparent.png",
    scholar:
      "https://png.pngtree.com/element_origin_min_pic/17/09/17/58c7e2f4435c8bfc09400154cdd9b89e.jpg"
  },
  snackbar: {
    value: false,
    message: ""
  }
});

export const mutations = {
  setUser: (state, payload) => {
    state.user = payload;
  },

  setScholars: (state, payload) => {
    state.scholars = payload;
  },

  addScholar: (state, payload) => {
    state.scholars.push(payload);
  },

  toggleDrawer: (state, payload) => {
    state.drawer = payload ?? !state.drawer;
  },

  toggleSnackbar: (state, payload) => {
    if (state.snackbar.value) {
      state.snackbar.value = false;
    }

    state.snackbar.value = payload ?? !state.snackbar.value;
  },

  setSnackbarMessage: (state, message) => {
    state.snackbar.message = message;
  }
};

export const getters = {
  scholarWallets: state => state.scholars.map(scholar => scholar.ronin_address),

  validationRules: _ => ({
    required: [v => !!v || "This field is required"]
  })
};

export const actions = {
  async rpc(_, rpc) {
    return await this.$axios.$post(
      `${this.$config.SUPABASE_URL}/rest/v1/rpc/${rpc}`,
      {},
      {
        headers: {
          apiKey: this.$config.SUPABASE_KEY
        }
      }
    );
  },

  async inviteToSupabase(_, email) {
    const payload = {
      email
    };
    const options = {
      headers: {
        "Content-Type": "application/json",
        Authorization: `${localStorage.getItem("auth._token.local")}`
      }
    };
    return await axios.post(
      `${this.$config.AWS_API_BASE_URL}/inviteToSupabase`,
      payload,
      options
    );
  },

  async init({ dispatch }) {
    await dispatch("fetchUser");

    const refreshToken = this.$auth.strategy.refreshToken.get();
    const { data, error } = await this.$supabase.auth.signIn({
      refreshToken
    });

    if (error) {
      console.error(error);
    }

    this.$auth.strategy.refreshToken.set(data?.refresh_token);
  },

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
  },

  async getProfileImage({ state }) {
    const url = state?.user?.profile_image_url;
    const defaultUrl = "supabase-logo.jpg";

    if (!url) return defaultUrl;

    const { data, error, publicURL } = this.$supabase.storage
      .from("public")
      .getPublicUrl(url);

    if (error) {
      console.error(error);
      return defaultUrl;
    }

    return publicURL || defaultUrl;
  }
};
