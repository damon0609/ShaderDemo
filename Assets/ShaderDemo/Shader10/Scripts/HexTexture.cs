using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HexTexture : MonoBehaviour {
    public Material material;
    public int pointCount = 100;

    [ContextMenu ("Done")]
    void UpdateAction () {

        Vector4[] points = new Vector4[pointCount];
        Vector4[] properties = new Vector4[pointCount];
        for (int i = 0; i < pointCount; i++) {

            float x = Random.Range (-0.9f, 0.9f);
            float y = Random.Range (-0.5f, 0.5f);
            Vector4 point = new Vector4 (x, y, 0, 0);
            points[i] = point;

            float radius = Random.Range (0, 0.25f);
            float intensity = Random.Range (-0.25f, 1);
            Vector2 property = new Vector2 (radius, intensity);
            properties[i] = property;
        }
        material.SetFloat("_point_length",pointCount);
        material.SetVectorArray ("_points",points);
        material.SetVectorArray("_properties",properties);
    }
    void Start () {

    }

    void Update () {

    }
}