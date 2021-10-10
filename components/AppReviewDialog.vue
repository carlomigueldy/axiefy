<template>
  <v-dialog :value="value" @input="onInput" width="500">
    <v-form ref="form" @submit.prevent="submit">
      <app-dialog-card>
        <v-card-title>Let us know what you think!</v-card-title>
        <v-card-text>
          <v-textarea
            class="mt-10"
            v-model="form.message"
            label="Message"
            placeholder="Got a feature request or anything that you don't like?"
            :rules="$store.getters.validationRules.required"
            outlined
          ></v-textarea>

          <v-card-actions>
            <v-spacer></v-spacer>
            <div>
              <v-btn @click="onCancel" text>Cancel</v-btn>
              <v-btn
                type="submit"
                :loading="loading$"
                depressed
                color="primary"
              >
                Submit Review
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
      message: ""
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
        return this.$toast("Must have a message");
      }

      try {
        this.loading$ = true;
        const { data, error } = await this.$supabase
          .from("reviews")
          .insert(this.form);

        if (error) {
          console.error(error);
          this.$toast(error.message);
          return;
        }

        this.$emit("input", false);
        this.$toast("Thank you so much for the feedback! 🎉");
        this.form.message = "";
      } catch (error) {
        console.error(error);
      } finally {
        this.loading$ = false;
      }
    }
  }
};
</script>
