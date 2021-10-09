export default ({ app }, inject) => {
  inject("stringUtil", {
    truncateWallet: value => {
      if (!value) {
        return "";
      }

      if (value.length === 0) return "";

      return `${value[0]}${value[1]}${value[2]}...${value[value.length - 3]}${
        value[value.length - 2]
      }${value[value.length - 1]}`.trim();
    }
  });
};
