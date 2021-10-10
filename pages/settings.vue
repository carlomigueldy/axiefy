<template>
  <app-main-container>
    <template v-slot:title>{{ title }}</template>
    <template v-slot:action>
      <v-btn @click="showReviewDialog" depressed>Feedback</v-btn>
    </template>

    <v-row>
      <v-col>
        <v-alert border="left" color="deep-purple accent-4" dense dark>
          <div class="text-h6">Donate</div>
          <p>Donations are welcome</p>
          <v-btn
            href="https://www.buymeacoffee.com/carlomigueldy"
            depressed
            target="_blank"
          >
            ☕ Buy me a Coffee
          </v-btn>
        </v-alert>

        <v-card outlined>
          <v-card-title>Account</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <app-tooltip bottom message="Click to select image">
              <app-file-input @change="onFileChange" type="image">
                <v-sheet rounded color="transparent" width="200" height="200">
                  <v-img
                    :src="fileForm.preview || userProfileImage"
                    lazy-src="supabase-logo.jpg"
                    class="rounded"
                    width="200"
                    height="200"
                  >
                    <template v-slot:placeholder>
                      <v-row
                        class="fill-height ma-0"
                        align="center"
                        justify="center"
                      >
                        <v-progress-circular
                          indeterminate
                          color="grey lighten-5"
                        ></v-progress-circular>
                      </v-row>
                    </template>
                  </v-img>
                </v-sheet>
              </app-file-input>
            </app-tooltip>

            <v-sheet height="25" color="transparent"></v-sheet>

            <v-sheet width="325" class="my-5" color="transparent">
              <v-form ref="form" @submit.prevent="updateProfile">
                <v-text-field
                  v-model="form.name"
                  label="Name"
                  :rules="$store.getters.validationRules.required"
                  hint="Required"
                  persistent-hint
                  outlined
                  dense
                  aria-autocomplete="none"
                  autocomplete="new-name"
                ></v-text-field>

                <v-text-field
                  v-model="form.ronin_address"
                  label="Ronin Wallet Address"
                  placeholder="ronin:0x0...000"
                  :rules="$store.getters.validationRules.required"
                  hint="Required"
                  persistent-hint
                  outlined
                  dense
                  aria-autocomplete="none"
                  autocomplete="new-ronin-wallet-address"
                ></v-text-field>

                <v-btn color="primary" :loading="loading$" type="submit">
                  Update
                </v-btn>
              </v-form>
            </v-sheet>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <app-security-container />
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <app-billing-container ref="billing" id="billing" />
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <app-danger-zone-container ref="danger-zone" id="danger-zone" />
      </v-col>
    </v-row>

    <v-sheet height="300" color="transparent"></v-sheet>

    <app-review-dialog v-model="dialog.review" />
  </app-main-container>
</template>

<script>
const TITLE = "Settings";

export default {
  head: {
    title: TITLE
  },

  data: () => ({
    fileForm: {},
    loading$: false,
    dialog: {
      review: false
    },
    form: {
      name: "",
      profile_image_url: "",
      ronin_address: "",
      profile_image_file: null
    },
    userProfileImage: null
  }),

  async created() {
    const { section } = this.$route.query;

    console.log("created", { section });

    if (section) {
      setTimeout(() => {
        this.$vuetify.goTo(this.$refs[section]);
      }, 100);
    }

    this.form.name = this.$store.state?.user?.name;
    this.form.ronin_address = this.$store.state?.user?.ronin_address;

    this.userProfileImage = await this.$store.dispatch("getProfileImage");
  },

  computed: {
    title() {
      return TITLE;
    }
  },

  methods: {
    showReviewDialog() {
      this.dialog.review = true;
    },

    onFileChange(event) {
      console.log("onFileChange", event);
      this.fileForm = event;
      this.form.profile_image_file = event.file;
    },

    async updateProfile() {
      console.log("updateProfile", this.form);

      if (!this.$refs.form.validate()) {
        return this.$toast.show("Must fill in required fields");
      }

      try {
        this.loading$ = true;

        await this._updateUser();

        if (!this.form?.profile_image_file) {
          return;
        }

        const profileImagePath = `${this.$auth.user.id}/profile-image.png`;
        await this.$supabase.storage.from("public").remove([profileImagePath]);
        const { data, error } = await this.$supabase.storage
          .from("public")
          .upload(profileImagePath, this.form?.profile_image_file, {
            cacheControl: "3600",
            upsert: false
          });
        console.log("updateProfile | storage upload", data);

        if (error) {
          console.error(error);
          return this.$toast.show(error.message);
        }

        const [_, url] = data.Key.split("public/");
        console.log("updateProfile | url", { url });
        this.form.profile_image_url = url;

        await this._updateUser();

        return this.$toast.show("Profile updated");
      } catch (error) {
        this.$toast.showUnexpectedError();
        console.error(error);
      } finally {
        this.loading$ = false;
      }
    },

    async _updateUser() {
      const { name, profile_image_url, ronin_address } = this.form;
      try {
        const { error } = await this.$supabase
          .from("users")
          .update({
            name,
            ronin_address,
            ...(profile_image_url ? { profile_image_url } : null)
          })
          .eq("id", this.$auth.user?.id);

        if (error) {
          console.error(error);
          return this.$toast.show(error.message);
        }

        this.form.profile_image_url = "";
      } catch (error) {
        this.$toast.showUnexpectedError();
        console.error(error);
      }
    }
  }
};
</script>

<style></style>
