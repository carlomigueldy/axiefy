<template>
  <app-main-container>
    <template v-if="!loading$" v-slot:title>
      {{ user.name || user.email }}
    </template>

    <v-row>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="Total SLP"
          :image-url="slpImg"
          :value="slp.total"
        />
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="In Game SLP"
          :image-url="slpImg"
          :value="slp.inGameSLP"
        />
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="Ronin SLP"
          :image-url="slpImg"
          :value="slp.roninSLP"
        />
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="Daily Average"
          :image-url="slpImg"
          :value="slp.dailySLP"
        />
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="Farmed Today"
          :image-url="slpImg"
          :value="slp.farmedToday"
        />
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="Current MMR"
          :image-url="arenaImg"
          :value="mmr"
        >
          <template v-slot:image>
            <v-img
              class="rounded-circle"
              :src="arenaImg"
              max-height="35"
              max-width="35"
            ></v-img>
          </template>
        </app-simple-data-card>
      </v-col>
    </v-row>

    <v-divider class="mt-10" />

    <div class="mt-5">
      <h2>{{ axies.length }} Axies</h2>
    </div>

    <v-row align="center" justify="center">
      <v-col cols="12" md="2" v-for="axie in axies" :key="axie.id">
        <app-axie-card :axie="axie" />
      </v-col>
    </v-row>
  </app-main-container>
</template>

<script>
import axios from "axios";
import {
  AXIE_RAPID_API_BASE_URL,
  AXIE_GAME_API_BASE_URL
} from "../../constants/index.js";

export default {
  data: () => ({
    user: null,
    loading$: false,
    slp: {
      total: "--",
      roninSLP: "--",
      inGameSLP: "--",
      dailySLP: "--",
      farmedToday: "--",
      lastClaimedSLP: 0
    },
    mmr: "--",
    rank: "--",
    axies: []
  }),

  computed: {
    slpImg() {
      return this.$store.state.assets.slp;
    },
    arenaImg() {
      return this.$store.state.assets.arena;
    }
  },

  async created() {
    this.loading$ = true;
    /** @todo to be removed */
    const wallet = "0xc20dabcad7bf3971fb11e89bf50bf2ff6dec0fd3";

    try {
      await Promise.all([
        this.getUserAxies(wallet),
        this.getUserInfo(wallet),
        (async () => {
          const { data, error } = await this.$supabase
            .from("users")
            .select()
            .eq("id", this.$route.params.id)
            .single();

          this.user = data;
        })()
      ]);

      this.getDailySLP();
    } catch (error) {
      console.error(error);
    } finally {
      this.loading$ = false;
    }
  },

  methods: {
    async getUserAxies(wallet) {
      try {
        const response = await this.$axios.$get(
          `${AXIE_RAPID_API_BASE_URL}/get-axies/${wallet}`,
          {
            headers: {
              "x-rapidapi-host": "axie-infinity.p.rapidapi.com",
              "x-rapidapi-key": this.$config.AXIE_RAPID_API_KEY
            }
          }
        );
        console.log("AXIES", response.data.axies.results);
        this.axies = response.data.axies.results;
      } catch (error) {
        console.log(error);
      }
    },

    async getUserInfo(wallet) {
      try {
        const response = await axios.get(
          `${AXIE_GAME_API_BASE_URL}/api/v1/${wallet}`,
          { accept: "application/json" }
        );

        console.log("NEW API", response);

        this.slp.total = response.data.total_slp;
        this.slp.inGameSLP = response.data.in_game_slp;
        this.slp.roninSLP = response.data.ronin_slp;
        this.slp.lastClaimedSLP = response.data.last_claim;
        this.mmr = response.data.mmr;
        this.rank = response.data.rank;

        await this.getFarmedSLPToday();
      } catch (error) {
        console.error(error);
      }
    },

    getDailySLP() {
      //  Date received from API
      const claimedDate = this.slp.lastClaimedSLP;
      const currentDate = Math.floor(new Date().getTime() / 1000.0);
      const dateDiff = currentDate - claimedDate;
      let daysDiff = dateDiff / (3600 * 24);

      console.log("Inputed", claimedDate);
      console.log(currentDate);
      console.log(Math.floor(daysDiff) + " days");

      this.slp.dailySLP = Math.ceil(this.slp.total / daysDiff);
      console.log(this.slp);
      console.log(daysDiff);
      console.log(this.slp.dailySLP);
    },

    async getFarmedSLPToday() {
      try {
        const response = await axios.get(
          `${AXIE_RAPID_API_BASE_URL}/get-update/0xc20dabcad7bf3971fb11e89bf50bf2ff6dec0fd3`,
          {
            headers: {
              "x-rapidapi-host": "axie-infinity.p.rapidapi.com",
              "x-rapidapi-key": this.$config.AXIE_RAPID_API_KEY
            }
          }
        );

        console.log("RESPONSE 2", response);

        this.slp.farmedToday = response.data.slp.todaySoFar;
      } catch (error) {
        console.log(error);
      }
    }
  }
};
</script>

<style></style>
