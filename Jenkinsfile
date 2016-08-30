stage 'Generate docs for branch ${env.BRANCH_NAME}'
node("master") {


    sh "rm -rf ./*"

    checkout scm
    //git url: 'https://github.com/orientechnologies/orientdb-docs.git', branch: "${env.BRANCH_NAME}"

    docker.image("orientdb/jenkins-slave-gitbook:20160511").inside() {
        sh "rm -rf _/book/*"
        sh "gitbook install . "
        sh "gitbook build ."
        sh "gitbook pdf . _book/OrientDB-Manual.pdf"
    }

    if (! ${env.BRANCH_NAME}.startWith("PR-")) {
        docker.image("orientdb/jenkins-slave-rsync:20160503").inside("-v /home/orient:/home/jenkins:ro") {
            sh "rsync -ravh --stats _book/  -e ${env.RSYNC_DOC}/${env.BRANCH_NAME}/"
        }
    }

}


