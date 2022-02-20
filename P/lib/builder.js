const path = require('path');
const fs = require('fs');

const dockerProvider = require("./dockerProvider");
const scriptsDir = path.join( path.dirname(require.main.filename), 'lib', 'scripts' );


class Builder {

    // Build and tag Dockerfile 
    async buildPackageImage() {
        await dockerProvider.build("p:latest", path.dirname("images/Dockerfile"));
    }

    // Create raw files needed for image.
    async buildRootfs() { 
        await dockerProvider.run("p:latest", `-v${scriptsDir}:/scripts`, "/scripts/make-rootfs.sh")
    }

    // Create syslinux image.
    async packageAsIso() { 

       // console.log("*NOT implemented*");

    }
}



module.exports = new Builder();