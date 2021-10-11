<template>
  <app-callback-container />
</template>

<script>
export default {
  auth: "guest",

  layout: "auth",

  async created() {
    if (Object.keys(this.$route.query).length !== 0) {
      const { access_token, refresh_token } = this.$route.query;

      await this.$auth.setUserToken(access_token, refresh_token);
      await this.$store.dispatch("init");
      return;
    }

    const [_, queryString] = this.$route.fullPath.split("callback#");
    console.log({ first: _, last: queryString });

    if (queryString) {
      setTimeout(() => {
        const path = `${window.location.origin}/?${queryString}`;
        window.location.replace(path);
      }, 1000);
      return;
    }

    return this.$router.push("/dashboard");
  }
};
</script>

<style></style>
