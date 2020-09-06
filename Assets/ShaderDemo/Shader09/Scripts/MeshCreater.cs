using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshCreater : MonoBehaviour {

    public int max_vertex = 4096;
    public Vector3[] vertexList;
    public Color[] colors;
    public Vector2[] uvs;
    public int[] indices;
    public float ranage;

    private void OnDrawGizmos() {
        if(Application.isPlaying)
        {
            foreach (var item in vertexList)
            {
                Gizmos.DrawSphere(item,0.1f);
            }
        }
    }

    Mesh InitMeshData () {

        vertexList = new Vector3[max_vertex * 3];
        for (int i = 0; i < max_vertex; i++) {
            float x = Random.Range (-ranage, ranage);
            float y = Random.Range (-ranage, ranage);
            float z = Random.Range (-ranage, ranage);

            Vector3 temp = new Vector3 { x = x, y = y, z = z };

            vertexList[i * 3 + 0] = temp;
            vertexList[i * 3 + 1] = temp;
            vertexList[i * 3 + 2] = temp;
        }

        indices = new int[max_vertex * 3];
        for (int i = 0; i < max_vertex * 3; i++) {
            indices[i] = i;
        }

        colors = new Color[max_vertex * 3];
        for (int i = 0; i < max_vertex; i++) {
            colors[i * 3 + 0] = new Color (1, 1, 1, 0);
            colors[i * 3 + 1] = new Color (1, 1, 1, 1);
            colors[i * 3 + 2] = new Color (1, 1, 1, 0);
        }

        uvs = new Vector2[max_vertex * 3];
        for (int i = 0; i < max_vertex; i++) {
            uvs[i * 3 + 0] = new Vector2 (1, 0);
            uvs[i * 3 + 1] = new Vector2 (1, 0);
            uvs[i * 3 + 2] = new Vector2 (0, 1);
        }

        Mesh mesh = new Mesh ();
        mesh.name = "rain";
        mesh.vertices = vertexList;
        mesh.uv = uvs;
        mesh.colors = colors;

        return mesh;
    }
    void Start () {

        MeshFilter filter = GetComponent<MeshFilter>();
        if(filter==null)
            filter = gameObject.AddComponent<MeshFilter>();

        filter.sharedMesh = InitMeshData();
        filter.mesh.SetIndices(indices,MeshTopology.Lines,0);

    }

    void Update () {

    }
}