using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotation_EulerAngles : MonoBehaviour
{
    public float rotationSpeed = 60f;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //эйлеровые углы
        transform.eulerAngles += new Vector3(rotationSpeed * Time.deltaTime, 0, rotationSpeed * Time.deltaTime);
    }
}
