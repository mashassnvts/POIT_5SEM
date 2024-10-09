using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScriptPosition : MonoBehaviour
{
    public float speedX = 2f;
    public float speedY = 2f; 
    public float speedZ = 1f;

    // Update is called once per frame
    void Update()
    {
        Vector3 pos = transform.position;
        Vector3 npos = new Vector3(pos.x + speedX * Time.deltaTime,pos.y + speedY * Time.deltaTime, pos.z + speedZ * Time.deltaTime); 
        transform.position = npos;

        if (pos.x > Camera.main.ScreenToWorldPoint(new Vector3(Screen.width, 0, 0)).x + 1)
        {
            gameObject.SetActive(false); 
        }
    }
}