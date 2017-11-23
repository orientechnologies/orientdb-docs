stage 'Generate docs for branch ${env.BRANCH_NAME}'
node("master") {

    sh "rm -rf ./*"

    checkout scm
    echo "building docs for branch  ${env.BRANCH_NAME}"
    
    def containerName = env.JOB_NAME.replaceAll(/\//, "_") + 
            "_build_${currentBuild.number}"
			
    def appNameLabel = "docker_ci";
    def taskLabel = env.JOB_NAME.replaceAll(/\//, "_")

    
	lock("label": "memory", "quantity":2) {	
    		docker.image("orientdb/jenkins-slave-gitbook:6.0.0").inside("--label collectd_docker_app=${appNameLabel} --label collectd_docker_task=${taskLabel}" + 
                                                                " --name ${containerName} --memory=2g") {
        		sh "rm -rf _/book/*"
        		sh "gitbook install --gitbook 3.1.1 . "
        		sh "gitbook build --gitbook 3.1.1 ."
        		sh "gitbook pdf --gitbook 3.1.1 . _book/OrientDB-Manual.pdf"
    		}
	}

    if (!env.BRANCH_NAME.startsWith("PR-")) {
        echo "sync generated content to OrientDB site"
	    lock("label": "memory", "quantity":2) {
        	docker.image("orientdb/jenkins-slave-rsync:20160503").inside("--label collectd_docker_app=${appNameLabel} --label collectd_docker_task=${taskLabel}" + 
                                                                     " --name ${containerName} -v /home/orient:/home/jenkins:ro") {
            		sh "rsync -ravh --stats _book/  -e ${env.RSYNC_DOC}/${env.BRANCH_NAME}/"
        	}
	    }
    } else {
        echo "it's a PR, no sync required"
    }

}


