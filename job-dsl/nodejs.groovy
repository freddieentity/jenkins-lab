job('NodeJS seed example') {
    scm {
        git('https://github.com/freddie-entity/nodejs-ft-jenkins.git') {  node -> // is hudson.plugins.git.GitSCM
            node / gitConfigName('freddie-entity')
            node / gitConfigEmail('nguyentrungtinc4nh1516@gmail.com')
        }
    }
    triggers {
        scm('H/5 * * * *')
    }
    wrappers {
        nodejs('nodejs') // this is the name of the NodeJS installation in 
                         // Manage Jenkins -> Configure Tools -> NodeJS Installations -> Name
    }
    steps {
        shell("npm install")
    }
}