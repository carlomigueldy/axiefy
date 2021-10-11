<template>
  <div>
    <v-form ref="form" @submit.prevent="onSubmit">
      <v-card outlined>
        <v-card-title>Security</v-card-title>
        <v-divider />
        <v-card-text>
          <v-sheet color="transparent" width="325">
            <v-text-field
              v-model="form.password"
              type="password"
              label="New Password"
              outlined
              aria-autocomplete="none"
              autocomplete="new-password"
              :rules="$store.getters.validationRules.required"
              dense
            ></v-text-field>

            <v-btn color="primary" :loading="check.loading$" type="submit">
              Save
            </v-btn>
          </v-sheet>
        </v-card-text>
      </v-card>
    </v-form>

    <v-dialog width="500" v-model="dialog.confirm">
      <app-dialog-card>
        <v-card-title>Confirm Password</v-card-title>
        <v-card-text>
          <v-form ref="confirmation" @submit.prevent="confirmPassword">
            <p>Enter your current password</p>

            <v-text-field
              label="Password"
              v-model="confirmation.password"
              :rules="$store.getters.validationRules.required"
              class="mt-10"
              hint="Your current password"
              type="password"
              persistent-hint
              outlined
              dense
              autocomplete="confirm-password"
            ></v-text-field>

            <v-card-actions>
              <v-spacer />
              <div>
                <v-btn @click="dialog.confirm = false" text>Cancel</v-btn>
                <v-btn
                  type="submit"
                  :loading="confirmation.loading$"
                  color="primary"
                  depressed
                >
                  Confirm
                </v-btn>
              </div>
            </v-card-actions>
          </v-form>
        </v-card-text>
      </app-dialog-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  data: () => ({
    check: {
      loading$: false
    },
    form: {
      password: "",
      loading$: false
    },
    confirmation: {
      password: "",
      loading$: false
    },
    dialog: {
      confirm: false
    }
  }),

  methods: {
    async onSubmit() {
      if (!this.$refs.form.validate()) {
        return;
      }

      this.check.loading$ = true;

      const { data, error } = await this.$supabase.rpc("has_password");
      this.check.loading$ = false;

      if (error) {
        return this.$toast.show(error.message);
      }

      if (!data) {
        return await this.update();
      }

      this.dialog.confirm = true;
    },

    async confirmPassword() {
      console.log("confirmPassword->state", this.confirmation);

      if (!this.$refs.confirmation.validate()) {
        return this.$toast.show("Must enter your current password to verify");
      }

      try {
        this.confirmation.loading$ = true;
        const { password } = this.confirmation;

        const { data, error } = await this.$supabase.auth.signIn({
          email: this.$auth.user.email,
          password
        });
        console.log("confirmPassword", { data, error });
        await this.$store.dispatch("init");

        if (error) {
          return this.$toast.show("Failed to verify your password");
        }

        await this.update();
      } catch (error) {
        this.$toast.showUnexpectedError();
        console.error(error);
      } finally {
        this.confirmation.loading$ = false;
      }
    },

    async update() {
      this.form.loading$ = true;
      const { password } = this.form;
      try {
        const { error } = await this.$supabase.auth.update({
          password
        });

        if (error) {
          console.error(error);
          return this.$toast.show(error.message);
        }

        this.$toast.show("Password updated");
      } catch (error) {
        this.$toast.showUnexpectedError();
        console.error(error);
      } finally {
        this.form.loading$ = false;
      }
    }
  }
};
</script>

<style></style>
