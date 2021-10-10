export default ({ $supabase }, inject) => {
  inject("util", {
    getProfileImageUrl: value => {
      const defaultUrl = "supabase-logo.jpg";

      if (!value) return defaultUrl;

      const { error, publicURL } = $supabase.storage
        .from("public")
        .getPublicUrl(value);

      if (error) {
        console.error(error);
        return defaultUrl;
      }

      return publicURL || defaultUrl;
    }
  });
};
