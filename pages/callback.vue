<template>
  <div>
    <iframe
      src="https://giphy.com/embed/Sqa4huGTDwJZNtvMky"
      width="480"
      height="268"
      frameBorder="0"
      class="giphy-embed"
      allowFullScreen
    ></iframe>
    <p>
      <a
        href="https://giphy.com/gifs/ctvcomedy-lights-out-david-spade-call-back-Sqa4huGTDwJZNtvMky"
      >
        via GIPHY
      </a>
    </p>
  </div>
</template>

<script>
export default {
  async created() {
    if (Object.keys(this.$route.query).length !== 0) {
      const { access_token, refresh_token } = this.$route.query;

      await this.$auth.setUserToken(access_token, refresh_token);
      return;
    }

    const [_, queryString] = this.$route.fullPath.split("#");
    console.log({ first: _, last: queryString });

    if (queryString) {
      const path = `${window.location.origin}/?${queryString}`;
      window.location.replace(path);
      return;
    }
  }
};
</script>

<style></style>
