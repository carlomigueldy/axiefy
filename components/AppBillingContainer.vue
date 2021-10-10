<template>
  <v-card id="billing" ref="billing" outlined>
    <v-card-title>Billing</v-card-title>
    <v-divider></v-divider>
    <v-card-text class="d-flex justify-space-around align-center pa-10">
      <app-plan-preview-card
        title="Free Tier"
        description="Pay Nothing like Jon Snow"
        subtitle="Coming soon"
        emoji="💡"
      />

      <app-plan-preview-card
        title="Basic"
        description="Can't Afford Premium?"
        subtitle="Coming soon"
        emoji="🍕"
      />

      <app-plan-preview-card
        title="Premium"
        description="PRO TIP: Not Worth It"
        subtitle="Coming soon"
        emoji="👑"
      />
    </v-card-text>
  </v-card>
</template>

<script>
export default {};
</script>

<style></style>
