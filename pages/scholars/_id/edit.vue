<template>
  <v-row>
    <v-col cols="6">
      <v-form ref="form" @submit.prevent="update">
        <v-card outlined>
          <v-card-title>Edit</v-card-title>
          <v-divider />
          <v-card-text>
            <v-text-field
              v-model="form.name"
              :rules="validationRules.required"
              hint="Required"
              persistent-hint
              label="Name"
              outlined
              dense
            ></v-text-field>

            <v-text-field
              v-model="form.ronin_address"
              label="Ronin Address"
              :rules="validationRules.required"
              hint="Required"
              persistent-hint
              outlined
              dense
            ></v-text-field>
            <v-btn class="mt-5" large color="primary" type="submit">
              Update
            </v-btn>
          </v-card-text>
        </v-card>
      </v-form>
    </v-col>
  </v-row>
</template>

<script>
import { mapGetters, mapState } from "vuex";

export default {
  data: () => ({
    form: {
      name: "",
      ronin_address: ""
    }
  }),

  computed: {
    ...mapState("users", ["user"]),

    ...mapGetters(["validationRules"])
  },

  created() {
    this.form.name = this.user.name;
    this.form.ronin_address = this.user.ronin_address;
  },

  methods: {
    async update() {
      if (!this.$refs.form.validate()) {
        return this.$toast("Please fill in the required fields");
      }

      try {
        const { error, data } = await this.$supabase
          .from("users")
          .update(this.form)
          .eq("id", this.$route.params.id);

        if (error) {
          console.error(error);
          return this.$toast(error.message);
        }

        return this.$toast("Updated");
      } catch (error) {
        console.error(error);
      }
    }
  }
};
</script>

<style></style>
