<template>
    <v-row>
        <v-col class="text-center">
            Dashboard
        </v-col>
    </v-row>
</template>


<script>

    export default{
        data() {
            return {

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
                    console.log(response.data.axies.results)
                })
            },
            async getUserInfo() {
                await this.$axios.$get('https://axie-infinity.p.rapidapi.com/get-update/0xc20dabcad7bf3971fb11e89bf50bf2ff6dec0fd3', {
                    headers: {
                        'x-rapidapi-host': 'axie-infinity.p.rapidapi.com',
                        'x-rapidapi-key': 'b5e6783431msh5dfe6faf063f956p16dfadjsnab843e1e67cd'
                    }
                }).then((response) => {
                    console.log(response)
                })
            }
        }
    }

</script>
