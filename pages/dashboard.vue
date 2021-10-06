<template>
    <app-main-container>
        <v-row>
            <v-col class="text-center">
                Dashboard
            </v-col>
        </v-row>
        <v-row>
            <v-col
                cols="12"
                md="2"
                sm="2"
            >
                <v-card>
                    <v-card-text>
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
                slp: 0
            }
        },
        created() {
            this.getUserAxies()
            this.getUserInfo()
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
                })
            }
        }
    }

</script>
