<template>
  <v-container fill-height>
    <v-row justify="center" align="center">
      <v-col>
        <div class="text-center ">
          <app-logo class="mb-5 display-4" />

          <div class="mt-10">
            <iframe
              allow="fullscreen"
              frameBorder="0"
              height="320"
              src="https://giphy.com/embed/u2wg2uXJbHzkXkPphr/video"
              width="400px"
              class="mb-10"
            ></iframe>
          </div>

          <div class="title">
            {{ $store.getters["funny/random"] }}
          </div>
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {};
</script>

