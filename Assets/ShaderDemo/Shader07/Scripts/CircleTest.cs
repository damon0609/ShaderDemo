using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CircleTest : MonoBehaviour
{
    private Material material;
    void Start()
    {
        material = transform.GetComponent<MeshRenderer>().material;
    }

    void Update()
    {
        
    }
}
