stage 'Generate docs for branch ${env.BRANCH_NAME}'
node("master") {


    sh "rm -rf ./*"

    checkout scm
    echo "building docs for branch  ${env.BRANCH_NAME}"

    docker.image("orientdb/jenkins-slave-gitbook:20160511").inside() {
        sh "rm -rf _/book/*"
        sh "gitbook install . "
        sh "gitbook build ."
        sh "gitbook pdf . _book/OrientDB-Manual.pdf"
    }

    if (!env.BRANCH_NAME.startsWith("PR-")) {
        echo "sync generated content to OrientDB site"
        docker.image("orientdb/jenkins-slave-rsync:20160503").inside("-v /home/orient:/home/jenkins:ro") {
            sh "rsync -ravh --stats _book/  -e ${env.RSYNC_DOC}/${env.BRANCH_NAME}/"
        }
    } else {
        echo "it's a PR, no sync required"
    }

}


