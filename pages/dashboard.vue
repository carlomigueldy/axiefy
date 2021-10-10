<template>
  <app-main-container>
    <v-row align="center" justify="center">
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card title="Total Gross SLP" :image-url="slpImg">
          {{ manager.gross }}
        </app-simple-data-card>
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card title="Total Share" :image-url="slpImg">
          {{ manager.net }}
        </app-simple-data-card>
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card title="Daily Share" :image-url="slpImg">
          {{ manager.daily }}
        </app-simple-data-card>
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card title="SLP Price" :image-url="slpImg">
          {{ slp.currentPrice }}
        </app-simple-data-card>
      </v-col>
    </v-row>
    <v-row align="center" justify="center">
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card title="Average MMR" :image-url="arenaImg">
          {{ averageMMR }}
        </app-simple-data-card>
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card title="Axies" :image-url="axieImg">
          {{ axies.count }}
        </app-simple-data-card>
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card title="Scholars" :image-url="scholarImg">
          {{ scholars.count }}
          <template v-slot:image>
            <span style="font-size: 40px">🎓</span>
          </template>
        </app-simple-data-card>
      </v-col>
    </v-row>
    
    <v-row class="mt-10" justify="center" align="center">
      <v-col cols="12" md="4">
        <v-card>
          <v-toolbar flat>
            <v-toolbar-title>Leaderboards</v-toolbar-title>
            <template v-slot:extension>
              <v-tabs
                color="white"
                align-with-title
                v-model="leaderboards.tabs.tab"
              >
                <v-tabs-slider color="white"></v-tabs-slider>
                <v-tab v-for="item in leaderboards.tabs.items" :key="item">
                  {{ item }}
                </v-tab>
              </v-tabs>
            </template>
          </v-toolbar>
          <v-data-table
            :headers="leaderboards.headers"
            :items="leaderboardsData"
            sort-by.sync="rank"
            :sort-desc.sync="sortDesc"
          >
          </v-data-table>
        </v-card>
      </v-col>
    </v-row>
  </app-main-container>
</template>

<script>
import AppMainContainer from "~/components/AppMainContainer.vue";
import {
  AXIE_RAPID_API_BASE_URL,
  AXIE_GAME_API_BASE_URL
} from "../constants/index.js";
import { formatUSD, formatPHP } from "~/utils/currencyFormatter.js";
import axios from "axios";

export default {
  components: { AppMainContainer },
  data() {
    return {
      sortDesc: false,
      slp: {
        currentPrice: 0,
        priceChangePercentage: 0
      },
      manager: {
        gross: 0,
        net: 0,
        daily: 0
      },
      axies: {
        count: 0
      },
      averageMMR: 0,
      scholars: {
        count: 0
      },
      leaderboards: {
        tabs: {
          tab: null,
          items: ["World", "Scholars"]
        },
        headers: [
          {
            text: "Rank",
            value: "rank"
          },
          {
            text: "Name",
            value: "name"
          },
          {
            text: "MMR",
            value: "elo"
          }
        ],
        items: {
          world: [],
          scholars: []
        }
      }
    };
  },
  computed: {
    slpImg() {
      return this.$store.state.assets.slp;
    },
    arenaImg() {
      return this.$store.state.assets.arena;
    },
    axieImg() {
      return this.$store.state.assets.axie;
    },
    scholarImg() {
      return this.$store.state.assets.scholar;
    },
    leaderboardsData: function() {
      switch (this.leaderboards.tabs.tab) {
        case 0:
          return this.leaderboards.items.world;
        case 1:
          return this.leaderboards.items.scholars;
      }
    }
  },
  created() {
    this.getTotalSLP();
    this.getSLPDetails();
    this.getTopPlayers();
  },
  methods: {
    async getTotalSLP() {
      try {
        const response = await axios.get(
          `${AXIE_GAME_API_BASE_URL}/api/v1/0xc20dabcad7bf3971fb11e89bf50bf2ff6dec0fd3,ronin:926813711d56434ea6f1e1ae8c53e47e2eface87,ronin:0a59a1440f03d4113a922c2b6b1f5918af2100a5,ronin:ca786a0d7259a866413261d7d08767aa9633ebd9`,
          {
            accept: "application/json"
          }
        );
        console.log("RESPONSE", response);

        const keys = Object.keys(response.data);

        const data = keys.map(key => {
          return {
            ...response.data[key],
            id: key
          };
        });

        this.leaderboards.items.scholars = data;
        console.log("MAPPING", data);
        this.scholars.count = data.length;
        data.forEach(item => {
          console.log(item.total_slp, item.name);
          this.manager.gross = this.manager.gross + item.total_slp;
          this.manager.daily = Math.ceil(
            this.manager.daily +
              this.getDailySLP(item.last_claim, item.in_game_slp)
          );
          this.averageMMR = this.averageMMR + item.mmr;
        });
        this.manager.net = Math.ceil(this.manager.gross * 0.6);
        console.log("MMR", this.averageMMR);
        this.averageMMR = Math.ceil(this.averageMMR / data.length);
        console.log("TOTAL", this.manager.gross);
        console.log("DAILY", this.manager.daily);
      } catch (error) {
        console.log(error);
      }
    },
    getDailySLP(claimedDate, slp) {
      const currentDate = Math.floor(new Date().getTime() / 1000.0);
      const dateDiff = (currentDate - claimedDate) / (3600 * 24);

      return Math.ceil(slp / dateDiff) * 0.6;
    },
    getTotalAxies() {},
    async getSLPDetails() {
      const response = await axios.get(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=smooth-love-potion&order=market_cap_desc&per_page=100&page=1&sparkline=false"
      );
      console.log("COIN", response);

      this.slp.currentPrice = formatUSD.format(response.data[0].current_price);
      this.slp.priceChangePercentage = Math.round(
        response.data[0].price_change_percentage_24h
      );
    },
    async getTopPlayers() {
      const response = await axios.get(
        "https://game-api.axie.technology/toprank?offset=0&limit=50",
        { accept: "application/json" }
      );
      console.log("TOP MMR", response);
      this.leaderboards.items.world = response.data.items;
    },
    orderByDesc(array) {},

    async created() {
      try {
        const response = await this.$store.dispatch("rpc", "get_team_members");
        this.$store.commit("setScholars", response);
      } catch (error) {
        console.error(error);
      }
    }
  }
};
</script>
