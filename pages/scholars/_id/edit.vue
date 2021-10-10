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

            <v-text-field
              v-model="form.share"
              type="number"
              label="Share %"
              :rules="validationRules.required"
              min="0"
              max="100"
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
      ronin_address: "",
      share: 0
    }
  }),

  computed: {
    ...mapState("users", ["user"]),

    ...mapGetters(["validationRules"])
  },

  created() {
    const [detail] = this.user.detail;

    this.form.name = this.user.name;
    this.form.ronin_address = this.user.ronin_address;
    this.form.share = detail?.share;
  },

  methods: {
    async update() {
      if (!this.$refs.form.validate()) {
        return this.$toast.show("Please fill in the required fields");
      }

      try {
        const { name, ronin_address } = this.form;
        const { error, data } = await this.$supabase
          .from("users")
          .update({ name, ronin_address })
          .eq("id", this.$route.params.id);

        if (error) {
          console.error(error);
          return this.$toast.show(error.message);
        }

        await this._updateShare();

        return this.$toast.show("Updated");
      } catch (error) {
        this.$toast.showUnexpectedError();
        console.error(error);
      }
    },

    async _updateShare() {
      const share = Number(this.form.share);
      const { data, error } = await this.$supabase
        .from("team_members")
        .update({
          share
        })
        .eq("user_id", this.$route.params.id);

      if (error) {
        console.error(error);
        return this.$toast.show(error.message);
      }

      return data;
    }
  }
};
</script>

<style></style>
