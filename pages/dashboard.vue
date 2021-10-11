<template>
  <app-main-container>
    <v-row align="center" justify="center">
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="Total Gross SLP"
          :image-url="slpImg"
          :value="manager.gross"
        />
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="Total Share"
          :image-url="slpImg"
          :value="manager.net"
        />
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="Daily Share"
          :image-url="slpImg"
          :value="manager.daily"
        />
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="SLP Price"
          :image-url="slpImg"
          :value="slp.currentPrice"
        />
      </v-col>
    </v-row>
    <v-row align="center" justify="center">
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="Average MMR"
          :image-url="arenaImg"
          :value="averageMMR"
          image-rounded
        />
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          imgReduceMargin
          imageSize="75"
          title="Axies"
          :image-url="axieImg"
          :value="axies.count"
        />
      </v-col>
      <v-col cols="12" md="2" sm="2">
        <app-simple-data-card
          title="Scholars"
          :image-url="scholarImg"
          :value="scholars.count"
        >
          <template v-slot:image>
            <span style="font-size: 40px">🎓</span>
          </template>
        </app-simple-data-card>
      </v-col>
    </v-row>

    <v-row class="mt-10" justify="center" align="center">
      <v-col cols="12" md="4">
        <v-card outlined>
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
      <v-col cols="12" md="4">
        <v-card>
          <highchart :options="chartOptions" />
        </v-card>
      </v-col>
    </v-row>
  </app-main-container>
</template>

<script>
import AppMainContainer from "~/components/AppMainContainer.vue";
import {
  AXIE_RAPID_API_BASE_URL,
  AXIE_GAME_API_BASE_URL,
  COIN_GECKO_API_BASE_URL
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
      scholar: {
        addresses: "",
        addressArr: []
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
      },
      chart: {
        title: "SLP Farmed by Each Scholars",
        chartType: "column",
        xCategories: [],
        xValues: []
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
    },
    chartOptions() {
      const ctx = this;
      return {
        title: {
          display: true,
          text: this.chart.title
        },
        chart: {
          type: this.chart.chartType
        },
        xAxis: {
          categories: this.chart.xCategories,
          labels: {
            style: {
              fontSize: "16px"
            }
          }
        },
        series: [
          {
            data: []
          }
        ]
      };
    }
  },
  async created() {
    const response = await this.$store.dispatch("users/all");
    this.$store.commit("setScholars", response);

    console.log(this.$store.state.scholars);
    await Promise.all([
      this.parseScholarAddress(),
      this.getTotalSLP(),
      this.getTotalAxies(),
      this.getSLPDetails(),
      this.getTopPlayers()
    ]);
  },
  methods: {
    async getTotalSLP() {
      if (this.scholar.addresses === null) return;
      try {
        const response = await axios.get(
          `${AXIE_GAME_API_BASE_URL}/api/v1/${this.scholar.addresses}`,
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
          console.log("ITEM", item.total_slp, item.name, item.mmr);
          if (item.total_slp !== undefined) {
            this.manager.gross = this.manager.gross + item.total_slp;
            this.chart.xCategories = item.name;
            this.chart.xValues = item.total_slp;
            this.manager.daily = Math.ceil(
              this.manager.daily +
                this.getDailySLP(item.last_claim, item.in_game_slp)
            );
            this.averageMMR = this.averageMMR + item.mmr;
          }
        });
        this.manager.net = Math.ceil(this.manager.gross * 0.6);
        console.log("MMR", this.averageMMR);
        this.averageMMR = Math.ceil(this.averageMMR / data.length);
        console.log("TOTAL", this.manager.gross);
        console.log("DAILY", this.manager.daily);
      } catch (error) {
        this.$toast.showUnexpectedError();
        console.log(error);
      }
    },
    getDailySLP(claimedDate, slp) {
      const currentDate = Math.floor(new Date().getTime() / 1000.0);
      const dateDiff = (currentDate - claimedDate) / (3600 * 24);

      return Math.ceil(slp / dateDiff) * 0.6;
    },
    async getTotalAxies() {
      if (this.scholar.addresses === null) return;
      console.log("AXIE", this.scholar.addressArr);
      try {
        for (let i = 0; i < this.scholar.addressArr.length; i++) {
          const response = await axios.get(
            `${AXIE_RAPID_API_BASE_URL}/get-axies/${this.scholar.addressArr[i]}`,
            {
              headers: {
                "x-rapidapi-host": "axie-infinity.p.rapidapi.com",
                "x-rapidapi-key": this.$config.AXIE_RAPID_API_KEY
              }
            }
          );
          this.axies.count = this.axies.count + response.data.data.axies.total;
          console.log("TOTAL", this.axies.count);
        }
      } catch (error) {
        console.log(error);
      }
    },
    async getSLPDetails() {
      const response = await axios.get(
        `${COIN_GECKO_API_BASE_URL}/api/v3/coins/markets?vs_currency=usd&ids=smooth-love-potion&order=market_cap_desc&per_page=100&page=1&sparkline=false`
      );
      console.log("COIN", response);

      this.slp.currentPrice = formatUSD.format(response.data[0].current_price);
      this.slp.priceChangePercentage = Math.round(
        response.data[0].price_change_percentage_24h
      );
    },
    async getTopPlayers() {
      const response = await axios.get(
        `${AXIE_GAME_API_BASE_URL}/toprank?offset=0&limit=50`,
        { accept: "application/json" }
      );
      console.log("TOP MMR", response);
      this.leaderboards.items.world = response.data.items;
    },

    parseScholarAddress() {
      var addressArrIndex = 0;
      for (let i = 0; i < this.$store.state.scholars.length; i++) {
        if (this.$store.state.scholars[i].ronin_address != null) {
          var address = this.$store.state.scholars[i].ronin_address.split(
            "ronin:"
          );
          this.scholar.addressArr[addressArrIndex] = "0x" + address[1];
          addressArrIndex++;
        }
      }
      for (let i = 0; i < this.scholar.addressArr.length; i++) {
        if (i == 0) {
          this.scholar.addresses =
            this.scholar.addresses + this.scholar.addressArr[i];
        } else {
          this.scholar.addresses =
            this.scholar.addresses + "," + this.scholar.addressArr[i];
        }
      }
      console.log("ADDRESS 1", this.scholar.addresses);
    }
  }
};
</script>
