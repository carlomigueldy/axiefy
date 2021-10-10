export default ({ app }, inject) => {
  inject("stringUtil", {
    truncateAddress: value => {
      if (!value) {
        return "";
      }

      if (value.length === 0) return "";

      const [first, second, third] = value;
      const firstThreeChars = [first, second, third].join("");
      const lastThreeChars = [
        value[value.length - 3],
        value[value.length - 2],
        value[value.length - 1]
      ].join("");

      return `${firstThreeChars}...${lastThreeChars}`.trim();
    },

    extractRoninAddress: address => {
      if (!address.includes("ronin:")) return null;

      const [_, wallet] = address.split("ronin:");

      return wallet;
    }
  });
};
