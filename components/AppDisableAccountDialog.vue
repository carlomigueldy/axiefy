<template>
  <v-dialog :value="value" @input="onInput" width="500">
    <v-form ref="form" @submit.prevent="submit">
      <app-dialog-card>
        <v-card-title>⚠️ Disable your account</v-card-title>
        <v-card-text>
          <p>
            Type in your email address
            <span class="font-weight-bold">{{ $auth.user.email }}</span> to
            confirm disabling account.
          </p>

          <v-text-field
            label="Your email"
            v-model="form.email"
            class="mt-10"
            outlined
            dense
          ></v-text-field>

          <v-card-actions>
            <v-spacer></v-spacer>
            <div>
              <v-btn @click="onCancel" text>Cancel</v-btn>
              <v-btn
                :disabled="form.email !== $auth.user.email"
                type="submit"
                :loading="loading$"
                depressed
                color="error"
              >
                Confirm
              </v-btn>
            </div>
          </v-card-actions>
        </v-card-text>
      </app-dialog-card>
    </v-form>
  </v-dialog>
</template>

<script>
export default {
  props: {
    value: Boolean
  },

  data: () => ({
    loading$: false,
    form: {
      email: ""
    }
  }),

  methods: {
    onInput(event) {
      this.$emit("input", event);
    },

    onCancel() {
      this.$emit("input", false);
    },

    async submit() {
      if (!this.$refs.form.validate()) {
        return this.$toast.show("Must have a message");
      }

      try {
        this.loading$ = true;
        const { data, error } = await this.$supabase.rpc(
          "disable_account",
          this.form
        );
        console.log(data);

        if (error) {
          console.error(error);
          this.$toast.show(error.message);
          return;
        }

        this.$emit("input", false);
        this.$toast.show("Your account has been disabled");
        this.$auth.logout();
      } catch (error) {
        this.$toast.showUnexpectedError();
        console.error(error);
      } finally {
        this.loading$ = false;
      }
    }
  }
};
</script>
