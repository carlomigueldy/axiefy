<template>
  <app-main-container>
    <template v-slot:title>{{ $route.params.id }}</template>
      <v-row>
        <v-col
            cols="12"
            md="2"
            sm="2"
        >
            <v-card
              min-height="70"
              
            >
              <v-card-title>
                <v-row
                  class="pt-5 px-5"
                  align="center"
                  justify="center"
                >
              
                  <v-img
                      src="https://assets.coingecko.com/coins/images/10366/large/SLP.png?1578640057"
                      max-height="35"
                      max-width="35"
                  ></v-img>
                  <div class="headline-1 mx-3">
                    {{ slp }}
                  </div>
                </v-row>
              </v-card-title>
                <v-row justify="center">
                  <v-card-title>Total SLP</v-card-title>
                </v-row>
            </v-card>
        </v-col>
        <v-col
            cols="12"
            md="2"
            sm="2"
        >
            <v-card
              min-height="70"
              
            >
              <v-card-title>
                <v-row
                  class="pt-5 px-5"
                  align="center"
                  justify="center"
                >
              
                  <v-img
                      src="https://assets.coingecko.com/coins/images/10366/large/SLP.png?1578640057"
                      max-height="35"
                      max-width="35"
                  ></v-img>
                  <div class="headline-1 mx-3">
                    {{ slp }}
                  </div>
                </v-row>
              </v-card-title>
                <v-row justify="center">
                  <v-card-title>In Game SLP</v-card-title>
                </v-row>
            </v-card>
        </v-col>
        <v-col
            cols="12"
            md="2"
            sm="2"
        >
            <v-card
              min-height="70"
              
            >
              <v-card-title>
                <v-row
                  class="pt-5 px-5"
                  align="center"
                  justify="center"
                >
              
                  <v-img
                      src="https://assets.coingecko.com/coins/images/10366/large/SLP.png?1578640057"
                      max-height="35"
                      max-width="35"
                  ></v-img>
                  <div class="headline-1 mx-3">
                    0
                  </div>
                </v-row>
              </v-card-title>
                <v-row justify="center">
                  <v-card-title>Ronin SLP</v-card-title>
                </v-row>
            </v-card>
        </v-col>
        <v-col
            cols="12"
            md="2"
            sm="2"
        >
            <v-card
              min-height="70"
              
            >
                <v-card-title>
                  <v-row
                    class="pt-5 px-5"
                    align="center"
                    justify="center"
                  >
                      <v-img
                          src="https://assets.coingecko.com/coins/images/10366/large/SLP.png?1578640057"
                          max-height="35"
                          max-width="35"
                      ></v-img>
                    <div class="headline-1 mx-3">
                      {{ dailySLP }} 
                    </div>
                  </v-row>
                </v-card-title>
                <v-row justify="center">
                  <v-card-title>Daily Average</v-card-title>
                </v-row>
            </v-card>
        </v-col>
        <v-col
            cols="12"
            md="2"
            sm="2"
        >
            <v-card
              min-height="70"
              
            >
                <v-card-title>
                  <v-row
                    class="pt-5 px-5"
                    align="center"
                    justify="center"
                  >
                      <v-img
                          src="https://assets.coingecko.com/coins/images/10366/large/SLP.png?1578640057"
                          max-height="35"
                          max-width="35"
                      ></v-img>
                    <div class="headline-1 mx-3">
                      {{ farmedToday }} 
                    </div>
                  </v-row>
                </v-card-title>
                <v-row justify="center">
                  <v-card-title>Farmed Today</v-card-title>
                </v-row>
            </v-card>
        </v-col>
        <v-col
            cols="12"
            md="2"
            sm="2"
        >
            <v-card
              min-height="70"
            >
                <v-card-title>
                  <v-row
                    class="pt-5 px-5"
                    align="center"
                    justify="center"
                  >
                    <v-img
                      class="rounded-circle"
                      src="https://chimeratribune.com/wp-content/uploads/2020/11/axieareanaswords.png"
                      max-height="35"
                      max-width="35"
                    ></v-img>
                    <div class="headline-1 mx-3">
                      {{ mmr }}
                    </div>
                  </v-row>
                </v-card-title>
                <v-row justify="center">
                  <v-card-title>Current MMR</v-card-title>
                </v-row>
            </v-card>
        </v-col>
      </v-row>
      <v-divider class="mt-10"></v-divider>
      <div class="mt-5">
        <h2>
        {{axies.length}} Axies
        </h2>
      </div>
      <v-row
        align="center"
        justify="center"
      >
        <v-col
          cols="12"
          md="2"
          v-for="axie in axies"
          :key="axie.id"
        >
          <v-card>
            <v-card-subtitle>
              Axie #{{ axie.id }}
            </v-card-subtitle>
            <v-card-text
              align="center"
              justify="center"
            >
              <v-img
                :src="axie.image"
                max-height="250"
                max-width="250"
              >
              </v-img>
            </v-card-text>
            
          </v-card>
        </v-col>
      </v-row>
  </app-main-container>
</template>

<script>
  export default{
    data() {
      return {
        slp: "--",
        dailySLP: "--",
        farmedToday: "--",
        lastClaimedSLP: 0,
        mmr: "--",
        axies: []
      }
    },
    async created() {
      await this.getUserAxies()
      await this.getUserInfo()
      this.getDailySLP()
    },
    methods: {
      async getUserAxies() {
        await this.$axios.$get('https://axie-infinity.p.rapidapi.com/get-axies/0xc20dabcad7bf3971fb11e89bf50bf2ff6dec0fd3', {
            headers: {
                'x-rapidapi-host': 'axie-infinity.p.rapidapi.com',
                'x-rapidapi-key': 'b5e6783431msh5dfe6faf063f956p16dfadjsnab843e1e67cd'
            }
        }).then((response) => {
            console.log("Axies",response.data.axies.results)
            this.axies = response.data.axies.results
        })
      },
      async getUserInfo() {
        await this.$axios.$get('https://axie-infinity.p.rapidapi.com/get-update/0xc20dabcad7bf3971fb11e89bf50bf2ff6dec0fd3', {
            headers: {
                'x-rapidapi-host': 'axie-infinity.p.rapidapi.com',
                'x-rapidapi-key': 'b5e6783431msh5dfe6faf063f956p16dfadjsnab843e1e67cd'
            }
        }).then((response) => {
            console.log("SLP",response)
            this.slp = response.slp.total
            this.lastClaimedSLP = response.slp.lastClaimedItemAt
            this.farmedToday = response.slp.todaySoFar
            this.mmr = response.leaderboard.elo
        })
        // await this.$axios.$get('https://game-api.axie.technology/api/v1/0xc20dabcad7bf3971fb11e89bf50bf2ff6dec0fd3'), {
        //   headers: {
        //     'Content-Type': 'application/json',
        //     'Authorization': 'Bearer ' + token
        //   }
        // }
        // .then((response) => {
        //     console.log("NEW API",response)
        // })
      },
      getDailySLP(){
        //  Date received from API
        const claimedDate = this.lastClaimedSLP
        const currentDate = Math.floor(new Date().getTime()/1000.0)
        const dateDiff = currentDate - claimedDate
        let daysDiff = dateDiff / (3600 * 24)

        console.log("Inputed",claimedDate)
        console.log(currentDate)
        console.log(Math.floor(daysDiff) + " days")

        this.dailySLP = Math.ceil(this.slp / daysDiff)
        console.log(this.slp)
        console.log(daysDiff)
        console.log(this.dailySLP)

      },
    }
  }
</script>

<style></style>
