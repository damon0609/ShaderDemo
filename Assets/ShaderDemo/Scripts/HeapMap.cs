using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeapMap : MonoBehaviour
{
    private Material mat;
    public int pointCount;

    public Vector4[] positions;
    public Vector4[] pointProper;

    public float range;
    void Start()
    {
        mat = GetComponent<MeshRenderer>().material;
        mat.SetInt("_PointLength", pointCount);
       
        positions = new Vector4[pointCount];
        pointProper = new Vector4[pointCount];

       
    }

    void Update()
    {
        for (int i = 0; i < positions.Length; i++)
        {
            positions[i] = new Vector2(Random.Range(-range, range), Random.Range(-range, range));
            pointProper[i] = new Vector2(Random.Range(0f, 0.25f), Random.Range(-0.25f, 1f)); // (Radius, Intensities)
        }
        mat.SetVectorArray("_Positions", positions);
        mat.SetVectorArray("_Properies", pointProper);
    }
}
