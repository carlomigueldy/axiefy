import colors from "vuetify/es5/util/colors";

export default {
  // Disable server-side rendering: https://go.nuxtjs.dev/ssr-mode
  ssr: false,

  // Target: https://go.nuxtjs.dev/config-target
  target: "static",

  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    titleTemplate: "%s - supaaxie",
    title: "supaaxie",
    meta: [
      { charset: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      { hid: "description", name: "description", content: "" },
      { name: "format-detection", content: "telephone=no" }
    ],
    link: [{ rel: "icon", type: "image/x-icon", href: "/favicon.ico" }]
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://google-fonts.nuxtjs.org/
    "@nuxtjs/google-fonts",
    // https://go.nuxtjs.dev/typescript
    "@nuxt/typescript-build",
    // https://go.nuxtjs.dev/vuetify
    "@nuxtjs/vuetify"
  ],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    "@nuxtjs/auth-next",
    [
      "nuxt-supabase",
      {
        supabaseUrl: process.env.SUPABASE_URL,
        supabaseKey: process.env.SUPABASE_KEY
      }
    ],
    // https://go.nuxtjs.dev/axios
    "@nuxtjs/axios",
    // https://go.nuxtjs.dev/pwa
    "@nuxtjs/pwa"
  ],

  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {},

  // PWA module configuration: https://go.nuxtjs.dev/pwa
  pwa: {
    manifest: {
      lang: "en"
    }
  },

  // Vuetify module configuration: https://go.nuxtjs.dev/config-vuetify
  vuetify: {
    customVariables: ["~/assets/variables.scss"],
    treeShake: true,
    theme: {
      dark: true,
      themes: {
        dark: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3
        }
      }
    }
  },

  googleFonts: {
    prefetch: true,
    families: {
      "DM Sans": true,
      Roboto: true,
      "Josefin+Sans": true,
      Lato: [100, 300],
      Raleway: {
        wght: [100, 400],
        ital: [100]
      }
    }
  },

  auth: {
    redirect: {
      login: "/login",
      logout: "/",
      callback: "/login",
      home: "/"
    },
    strategies: {
      local: {
        token: {
          property: "token",
          global: true,
          type: "Bearer"
        },
        user: {
          property: "data"
        },
        endpoints: {
          tokenType: "Bearer",
          autoFetchUser: true,
          login: {
            url: `${process.env.SUPABASE_URL}/auth/v1/token?grant_type=password`,
            method: "post",
            propertyName: "access_token",
            headers: {
              "Content-Type": "application/json",
              apiKey: process.env.SUPABASE_KEY,
              Authorization: `Bearer ${process.env.SUPABASE_KEY}`
            }
          },
          register: {
            url: `${process.env.SUPABASE_URL}/auth/v1/signup`,
            method: "post",
            headers: {
              "Content-Type": "application/json",
              apiKey: process.env.SUPABASE_KEY,
              Authorization: `Bearer ${process.env.SUPABASE_KEY}`
            }
          },
          user: {
            url: `${process.env.SUPABASE_URL}/auth/v1/user`,
            method: "get",
            headers: {
              apiKey: process.env.SUPABASE_KEY,
              Authorization: `Bearer ${process.env.SUPABASE_KEY}`
            }
          },
          logout: {
            url: `${process.env.SUPABASE_URL}/auth/v1/logout`,
            method: "post",
            headers: {
              "Content-Type": "application/json",
              apiKey: process.env.SUPABASE_KEY,
              Authorization: `Bearer ${process.env.SUPABASE_KEY}`
            }
          }
        }
      }
    }
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {}
};
