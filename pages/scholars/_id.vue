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
                      align="center"
                  >
                    <v-col>
                      <v-img
                          src="https://assets.coingecko.com/coins/images/10366/large/SLP.png?1578640057"
                          max-height="40"
                          max-width="40"
                      ></v-img>
                    </v-col>
                    <v-col>
                        {{ slp }} SLP
                    </v-col>
                  </v-row>
                </v-card-title>
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
                      align="center"
                  >
                    <v-col>
                      ELO
                    </v-col>
                    <v-col>
                        {{ mmr }} MMR
                    </v-col>
                  </v-row>
                </v-card-title>
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
        mmr: "--",
      }
    },
    created() {
      this.getUserAxies()
      this.getUserInfo()
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
            this.mmr = response.leaderboard.elo
        })
      },
      getDailySLP(){

        // const claimedDate = this.$moment.unix(1630951700).format("MM/DD/YYYY")
        const claimedDate = 1630951700
        const currentDate = new Date().getTime()
        const dateDiff = (currentDate - claimedDate)

        console.log(claimedDate)
        console.log(dateDiff)


      },
    }
  }
</script>

<style></style>
