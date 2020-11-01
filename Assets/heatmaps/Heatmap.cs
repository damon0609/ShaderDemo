// Alan Zucconi
// www.alanzucconi.com
using System.Collections;
using UnityEngine;

public class Heatmap : MonoBehaviour {

    public Vector4[] positions;

    public Vector4[] properties;
    public float[] radiuses;
    public float[] intensities;

    public Material material;

    public int count = 50;

    void Start () {
        positions = new Vector4[count];
        properties = new Vector4[count];
        radiuses = new float[count];
        intensities = new float[count];

        for (int i = 0; i < positions.Length; i++) {
            positions[i] = new Vector2 (Random.Range (-0.4f, +0.4f), Random.Range (-0.4f, +0.4f));
            radiuses[i] = Random.Range (0f, 0.5f);
            intensities[i] = Random.Range (0.25f, 1f);
        }
    }

    void Update () {
        material.SetInt ("_Points_Length", positions.Length);
        for (int i = 0; i < positions.Length; i++) {
            positions[i] += new Vector4 (Random.Range (-0.1f, +0.1f), Random.Range (-0.1f, +0.1f)) * Time.deltaTime*5f;

            Vector4 property = new Vector4 (radiuses[i], intensities[i]);
            properties[i] = property;
        }
        material.SetVectorArray ("_Points", positions);
        material.SetVectorArray ("_Properties", properties);

    }
}