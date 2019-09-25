const ChoiHo = artifacts.require("ChoiHo");

contract("ChoiHo", accounts => {
    let meta;
    it("can setup", () => {
        return ChoiHo.deployed()
            .then(instance => {
                meta = instance;
            })
            .then(instance => {
                return meta.setup.call(1, 1);
            })
            .then(instance => {
                return meta.getCurrentState.call();
            })
            .then(current_state => {
                console.log(current_state[1].toNumber());
            })
    });
    it("can not setup again", () => {
        return ChoiHo.deployed()
            .then(instance => {
                meta = instance;
            })
            .then(instance => {
                meta.setup.call(1, 1);
            })
            .then(instance => {
                meta.setup.call(2, 2);
            })
    })

});