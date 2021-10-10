<template>
  <app-main-container>
    <template v-slot:title>{{ title }}</template>
    <template v-slot:action>
      <v-btn depressed>Feedback</v-btn>
    </template>

    <v-row>
      <v-col>
        <v-alert border="left" color="deep-purple accent-4" dark>
          <div class="text-h6">Donate</div>
          <p>Donations are welcome</p>
          <v-btn
            href="https://www.buymeacoffee.com/carlomigueldy"
            depressed
            target="_blank"
          >
            Buy me a Coffee
          </v-btn>
        </v-alert>

        <v-card outlined>
          <v-card-title>Account</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
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

            <v-sheet height="25" color="transparent"></v-sheet>

            <v-sheet width="325" class="my-5" color="transparent">
              <v-form ref="form" @submit.prevent="updateProfile">
                <v-text-field
                  v-model="form.name"
                  label="Name"
                  outlined
                  dense
                  aria-autocomplete="none"
                  autocomplete="new-name"
                ></v-text-field>

                <v-text-field
                  v-model="form.password"
                  type="password"
                  label="New Password"
                  outlined
                  aria-autocomplete="none"
                  autocomplete="new-password"
                  dense
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
        <v-card id="billing" ref="billing" outlined>
          <v-card-title>Billing</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <div class="subtitle-1">Coming soon</div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <v-card outlined>
          <v-card-title>Danger Zone</v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <div class="subtitle-1">Delete your account forever</div>
            <v-sheet height="25" color="transparent"></v-sheet>
            <v-btn depressed large color="error">Delete Account</v-btn>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <v-sheet height="300" color="transparent"></v-sheet>
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
    form: {
      name: "",
      password: "",
      profile_image_url: "",
      profile_image_file: null
    },
    userProfileImage: null
  }),

  async created() {
    const { section } = this.$route.query;

    if (section) {
      this.$vuetify.goTo(this.$refs[section]);
    }

    this.form.name = this.$store.state?.user?.name;

    this.userProfileImage = await this.$store.dispatch("getProfileImage");
  },

  computed: {
    title() {
      return TITLE;
    }
  },

  methods: {
    onFileChange(event) {
      console.log("onFileChange", event);
      this.fileForm = event;
      this.form.profile_image_file = event.file;
    },

    async updateProfile() {
      console.log("updateProfile", this.form);

      try {
        this.loading$ = true;

        await Promise.all([this._updateAuthProfile(), this._updateUser()]);

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
          return this.$toast(error.message);
        }

        const [_, url] = data.Key.split("public/");
        console.log("updateProfile | url", { url });
        this.form.profile_image_url = url;

        await this._updateUser();

        return this.$toast("Profile updated");
      } catch (error) {
        console.error(error);
      } finally {
        this.loading$ = false;
      }
    },

    async _updateAuthProfile() {
      const { password } = this.form;
      try {
        const { error } = await this.$supabase.auth.update({
          password
        });

        if (error) {
          console.error(error);
          return this.$toast(error.message);
        }
      } catch (error) {
        console.error(error);
      }
    },

    async _updateUser() {
      const { name, profile_image_url } = this.form;
      try {
        const { error } = await this.$supabase
          .from("users")
          .update({
            name,
            ...(profile_image_url ? { profile_image_url } : null)
          })
          .eq("id", this.$auth.user?.id);

        if (error) {
          console.error(error);
          return this.$toast(error.message);
        }

        this.form.profile_image_url = "";
      } catch (error) {
        console.error(error);
      }
    }
  }
};
</script>

<style></style>
