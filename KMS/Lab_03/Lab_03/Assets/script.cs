using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class script : MonoBehaviour
{

    MeshRenderer rend;

    public float minX, maxX, minZ, maxZ;

    public float nX, nY, nZ;

    public GameObject cubePrefab;



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
        nX = Random.Range(minX, maxX);
        nZ = Random.Range(minZ, maxZ);

        if (Input.GetKeyDown(KeyCode.Q))
        {
            if (cubePrefab == null)
            {
                Debug.LogError("cubePrefab is not assigned!");
                return;
            }

            GameObject cub = Instantiate(cubePrefab, new Vector3(nX, nY, nZ), Quaternion.identity);
            cub.AddComponent<Rigidbody>();
        }


        if (Input.GetKeyDown(KeyCode.W))
        {
            Quaternion rotZ = Quaternion.AngleAxis(-1, new Vector3(0, 0, 1));
            gameObject.transform.rotation *= rotZ;
        }
    }
}
