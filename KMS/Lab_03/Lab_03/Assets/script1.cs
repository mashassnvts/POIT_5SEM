using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlaneScript : MonoBehaviour
{
    MeshRenderer rend;

    public float minX, maxX, minZ, maxZ; 
    public float nY;

    public GameObject cubePrefab; 
    public GameObject spherePrefab; 
    public GameObject prefab1; 

    // Start is called before the first frame update
    void Start()
    {
        rend = gameObject.GetComponent<MeshRenderer>();

        minX = rend.bounds.min.x;
        maxX = rend.bounds.max.x;
        minZ = rend.bounds.min.z;
        maxZ = rend.bounds.max.z;

        nY = gameObject.transform.position.y + 5; 
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            float nX = Random.Range(minX, maxX);
            float nZ = Random.Range(minZ, maxZ);
            GameObject cube = Instantiate(cubePrefab, new Vector3(nX, nY, nZ), Quaternion.identity);
            cube.AddComponent<Rigidbody>(); 
        }

        if (Input.GetKeyDown(KeyCode.Space))
        {
            float nX = Random.Range(minX, maxX);
            float nZ = Random.Range(minZ, maxZ);
            GameObject sphere = Instantiate(spherePrefab, new Vector3(nX, nY, nZ), Quaternion.identity);
            sphere.AddComponent<Rigidbody>(); 
        }

        if (Input.GetKeyDown(KeyCode.P))
        {
            float nX = Random.Range(minX, maxX);
            float nZ = Random.Range(minZ, maxZ);
            GameObject sphereFromPrefab1 = Instantiate(prefab1, new Vector3(nX, nY, nZ), Quaternion.identity);
            sphereFromPrefab1.AddComponent<Rigidbody>(); 
        }

        if (Input.GetKeyDown(KeyCode.W))
        {
            Quaternion rotZ = Quaternion.AngleAxis(-1, new Vector3(0, 0, 1)); 
            gameObject.transform.rotation *= rotZ; 
        }
    }
}
