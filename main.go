package main

//
// derived from: https://gist.github.com/ffledgling/62814ccbb12fd6b9ab6fd89da7e80cd2
//

import (
    "encoding/json"
    "log"
    "os"
    "path/filepath"
    "strconv"

    // We use pretty instead of the common go-spew or pretty-printing because,
    // go-spew is vendored in client-go and causes problems
    "github.com/kr/pretty"

    "k8s.io/client-go/kubernetes"
    "k8s.io/client-go/tools/clientcmd"

    apiv1 "k8s.io/api/core/v1"

    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
    extensionsv1beta1 "k8s.io/api/extensions/v1beta1"
    _ "k8s.io/client-go/plugin/pkg/client/auth/gcp"
    "k8s.io/client-go/util/homedir"
    "flag"
)


func ListDeployments() {


    // Number of apps
    N, err := strconv.Atoi(os.Args[1])
    if err != nil {
        panic(err.Error())
    }

    var kubeconfig *string
    if home := homedir.HomeDir(); home != "" {
        kubeconfig = flag.String("kubeconfig", filepath.Join(home, ".kube", "config"), "(optional) absolute path to the kubeconfig file")
    } else {
        kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
    }
    flag.Parse()


    for i := 2 ; i <= N*2 ; i+=2 {

        log.Printf("launch %s of %s", os.Args[i], os.Args[i+1])

        jj, err := strconv.Atoi(os.Args[i])
        replicas := int32(jj)

        dbjson := os.Args[i+1]


        // Read the Deployment's json.
        file, err := os.Open(dbjson)
        if err != nil {
            panic(err.Error())
        }

        dec := json.NewDecoder(file)

        // Parse it into the internal k8s structs
        var dep extensionsv1beta1.Deployment
        dec.Decode(&dep)
        *dep.Spec.Replicas = replicas

        depName := dep.ObjectMeta.Name + "-" + os.Args[len(os.Args)-1]
        dep.ObjectMeta.Name = depName

        // Dump the struct in case you want to see what it looks like
        pretty.Println(dep)


        config, err := clientcmd.BuildConfigFromFlags("", *kubeconfig)
        if err != nil {
            panic(err.Error())
        }

        // creates the clientset
        clientset, err := kubernetes.NewForConfig(config)
        if err != nil {
            panic(err.Error())
        }

        deploymentsClient := clientset.ExtensionsV1beta1().Deployments(apiv1.NamespaceDefault)

        // List existing deployments in namespace
        deployments, err := deploymentsClient.List(metav1.ListOptions{})
        if err != nil {
            log.Println(err)
        } else {
            for i, e := range deployments.Items {
                log.Printf("Deployment #%d\n", i)
                log.Printf("%s", e.ObjectMeta.SelfLink)
            }
        }

        // Create a new deployment based on our template.
        result, err := deploymentsClient.Create(&dep)
        if err != nil {
            log.Println("ERROR:", err.Error())
        } else {
            pretty.Println(result)
        }

    }

}

func main() {
    ListDeployments()
}
