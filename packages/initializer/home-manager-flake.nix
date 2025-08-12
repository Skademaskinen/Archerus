{
    inputs.archerus.url = "github:Skademaskinen/Archerus/work-ready-home-manager";
    outputs = inputs: {
        homeConfigurations."user" = inputs.archerus.homeConfigurations.default "user";
    };
}
