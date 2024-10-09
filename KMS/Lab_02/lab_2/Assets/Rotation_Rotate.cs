using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotation_Rotate : MonoBehaviour
{
    private Quaternion orig;
    // Start is called before the first frame update
    void Start()
    {
        orig = transform.rotation;
    }

    // Update is called once per frame
    void Update()
    {
        //вращение
        Quaternion rot1 = Quaternion.AngleAxis(3, Vector3.up);
        transform.rotation *= rot1;
    }
}
